package io.mesalabs.unica.ghostengine

import android.app.Activity
import android.location.Address
import android.location.Geocoder
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.ProgressBar
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import io.mesalabs.unica.ghostengine.R
import io.mesalabs.unica.ghostengine.location.StealthLocationManager
import kotlinx.coroutines.*
import kotlin.coroutines.resume

/**
 * Dialog-themed Activity for searching a spoofed GPS location.
 * Uses Android Geocoder (Google backend, zero API key needed).
 */
class GhostLocationSearchProxy : Activity() {

    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private var searchJob: Job? = null
    private lateinit var adapter: ResultsAdapter
    private lateinit var progress: ProgressBar
    private lateinit var noResults: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        showSearchDialog()
    }

    private fun showSearchDialog() {
        val view = layoutInflater.inflate(R.layout.dialog_location_search, null)
        val searchInput = view.findViewById<EditText>(R.id.location_search_input)
        progress  = view.findViewById(R.id.location_progress)
        noResults = view.findViewById(R.id.location_no_results)
        val recycler = view.findViewById<RecyclerView>(R.id.location_results)

        adapter = ResultsAdapter { onAddressSelected(it) }
        recycler.layoutManager = LinearLayoutManager(this)
        recycler.adapter = adapter

        searchInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) = Unit
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) = Unit
            override fun afterTextChanged(s: Editable?) { scheduleSearch(s?.toString()?.trim() ?: "") }
        })

        AlertDialog.Builder(this)
            .setTitle(getString(R.string.search_location_title))
            .setView(view)
            .setNegativeButton(R.string.cancel) { _, _ -> finish() }
            .setOnCancelListener { finish() }
            .show()
    }

    private fun onAddressSelected(address: Address) {
        val r = contentResolver
        Settings.System.putString(r, "unica_ghost_lat", address.latitude.toString())
        Settings.System.putString(r, "unica_ghost_lng", address.longitude.toString())
        Settings.System.putString(r, "unica_ghost_alt", "0")
        val name = listOfNotNull(
            address.featureName?.takeIf { it != address.locality },
            address.locality, address.adminArea, address.countryName
        ).distinct().joinToString(", ")
        Settings.System.putString(r, "unica_ghost_location_name", name)
        StealthLocationManager.updateSpoofedLocation(this, address.latitude, address.longitude)
        finish()
    }

    private fun scheduleSearch(query: String) {
        searchJob?.cancel()
        if (query.length < 2) { adapter.submitList(emptyList()); return }
        searchJob = scope.launch {
            delay(300)
            progress.visibility = View.VISIBLE
            noResults.visibility = View.GONE
            val results = withContext(Dispatchers.IO) { geocodeQuery(query) }
            progress.visibility = View.GONE
            if (results.isEmpty()) { noResults.visibility = View.VISIBLE; adapter.submitList(emptyList()) }
            else adapter.submitList(results)
        }
    }

    private suspend fun geocodeQuery(query: String): List<Address> {
        if (!Geocoder.isPresent()) return emptyList()
        return try {
            val gc = Geocoder(applicationContext)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                suspendCancellableCoroutine { cont ->
                    gc.getFromLocationName(query, 6) { addrs ->
                        if (cont.isActive) cont.resume(addrs)
                    }
                }
            } else {
                @Suppress("DEPRECATION")
                gc.getFromLocationName(query, 6) ?: emptyList()
            }
        } catch (_: Exception) { emptyList() }
    }

    override fun onDestroy() { scope.cancel(); super.onDestroy() }

    private inner class ResultsAdapter(private val onClick: (Address) -> Unit) :
        RecyclerView.Adapter<ResultsAdapter.VH>() {
        private val items = mutableListOf<Address>()
        fun submitList(list: List<Address>) { items.clear(); items.addAll(list); notifyDataSetChanged() }
        inner class VH(v: View) : RecyclerView.ViewHolder(v) {
            val title: TextView = v.findViewById(android.R.id.text1)
            val sub: TextView   = v.findViewById(android.R.id.text2)
        }
        override fun onCreateViewHolder(p: ViewGroup, t: Int) =
            VH(LayoutInflater.from(p.context).inflate(android.R.layout.simple_list_item_2, p, false))
        override fun getItemCount() = items.size
        override fun onBindViewHolder(h: VH, pos: Int) {
            val a = items[pos]
            val name = listOfNotNull(a.featureName?.takeIf { it != a.locality },
                a.locality, a.adminArea, a.countryName).distinct().joinToString(", ")
            h.title.text = name.ifEmpty { "%.4f, %.4f".format(a.latitude, a.longitude) }
            h.sub.text   = "%.5f, %.5f".format(a.latitude, a.longitude)
            h.itemView.setOnClickListener { onClick(a) }
        }
    }
}