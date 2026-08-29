package io.mesalabs.unica.prayertimes.ui

import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.RadioButton
import android.widget.TextView
import androidx.activity.result.ActivityResultLauncher
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import io.mesalabs.unica.prayertimes.Prefs
import io.mesalabs.unica.prayertimes.R
import io.mesalabs.unica.prayertimes.audio.AdhanSoundEntry
import io.mesalabs.unica.prayertimes.audio.AdhanSoundManager
import io.mesalabs.unica.prayertimes.audio.AdhanSoundType
import io.mesalabs.unica.prayertimes.calc.Prayer

class AdhanSoundPickerDialog(
    private val context: Context,
    private val prayer: Prayer,
    private val prefs: Prefs,
    private val onCustomFileRequested: (() -> Unit)? = null,
    private val onSoundSelected: (String) -> Unit
) {
    private var dialog: AlertDialog? = null
    private var selectedKey: String = prefs.getAdhanSoundKey(prayer.name)
    private val entries: List<AdhanSoundEntry> = AdhanSoundManager.getSoundEntriesForPrayer(prayer)

    fun show() {
        val view = LayoutInflater.from(context).inflate(R.layout.dialog_adhan_picker, null)
        val recyclerView = view.findViewById<RecyclerView>(R.id.recycler_adhan_sounds)
        recyclerView.layoutManager = LinearLayoutManager(context)

        val adapter = SoundAdapter()
        recyclerView.adapter = adapter

        dialog = AlertDialog.Builder(context)
            .setTitle(context.getString(R.string.pref_sounds_category) + " - " + getPrayerName(prayer))
            .setView(view)
            .setPositiveButton(R.string.ok) { _, _ ->
                AdhanSoundManager.stopPreview()
                prefs.setAdhanSoundKey(prayer.name, selectedKey)
                onSoundSelected(selectedKey)
            }
            .setNegativeButton(R.string.cancel) { _, _ ->
                AdhanSoundManager.stopPreview()
            }
            .setOnDismissListener {
                AdhanSoundManager.stopPreview()
            }
            .create()

        dialog?.show()
    }

    private fun getPrayerName(prayer: Prayer): String = when (prayer) {
        Prayer.FAJR -> context.getString(R.string.prayer_fajr)
        Prayer.SUNRISE -> context.getString(R.string.prayer_sunrise)
        Prayer.DHUHR -> context.getString(R.string.prayer_dhuhr)
        Prayer.ASR -> context.getString(R.string.prayer_asr)
        Prayer.MAGHRIB -> context.getString(R.string.prayer_maghrib)
        Prayer.ISHA -> context.getString(R.string.prayer_isha)
    }

    inner class SoundAdapter : RecyclerView.Adapter<SoundAdapter.SoundViewHolder>() {

        inner class SoundViewHolder(v: View) : RecyclerView.ViewHolder(v) {
            val radio: RadioButton = v.findViewById(R.id.radio_sound)
            val title: TextView = v.findViewById(R.id.text_sound_title)
            val btnPlay: ImageButton = v.findViewById(R.id.btn_sound_play)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SoundViewHolder {
            val v = LayoutInflater.from(parent.context).inflate(R.layout.item_adhan_sound, parent, false)
            return SoundViewHolder(v)
        }

        override fun getItemCount(): Int = entries.size

        override fun onBindViewHolder(holder: SoundViewHolder, position: Int) {
            val entry = entries[position]
            val isSelected = (entry.key == selectedKey)

            holder.radio.isChecked = isSelected
            holder.title.text = if (entry.type == AdhanSoundType.CUSTOM) {
                val customUri = prefs.getCustomAdhanUri(prayer.name)
                if (!customUri.isNullOrEmpty()) {
                    context.getString(R.string.adhan_custom) + " (" + (Uri.parse(customUri).lastPathSegment ?: "file") + ")"
                } else {
                    context.getString(R.string.adhan_custom)
                }
            } else {
                context.getString(entry.titleResId)
            }

            val isPlaying = AdhanSoundManager.isPlaying(entry.key)
            holder.btnPlay.setImageResource(
                if (isPlaying) android.R.drawable.ic_media_pause else android.R.drawable.ic_media_play
            )

            // Silent has no preview
            if (entry.type == AdhanSoundType.SILENT) {
                holder.btnPlay.visibility = View.GONE
            } else {
                holder.btnPlay.visibility = View.VISIBLE
            }

            holder.itemView.setOnClickListener {
                selectedKey = entry.key
                notifyDataSetChanged()
                if (entry.type == AdhanSoundType.CUSTOM) {
                    onCustomFileRequested?.invoke()
                }
            }

            holder.radio.setOnClickListener {
                selectedKey = entry.key
                notifyDataSetChanged()
                if (entry.type == AdhanSoundType.CUSTOM) {
                    onCustomFileRequested?.invoke()
                }
            }

            holder.btnPlay.setOnClickListener {
                if (AdhanSoundManager.isPlaying(entry.key)) {
                    AdhanSoundManager.stopPreview()
                    notifyDataSetChanged()
                } else {
                    val customUri = if (entry.type == AdhanSoundType.CUSTOM) prefs.getCustomAdhanUri(prayer.name) else null
                    AdhanSoundManager.startPreview(
                        context = context,
                        soundKey = entry.key,
                        customUriStr = customUri,
                        onComplete = { notifyDataSetChanged() },
                        onError = { notifyDataSetChanged() }
                    )
                    notifyDataSetChanged()
                }
            }
        }
    }
}