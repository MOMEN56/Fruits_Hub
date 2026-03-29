package com.example.fruit_hub

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper

class SplashActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Handler(Looper.getMainLooper()).postDelayed({
            val mainIntent = Intent(this, MainActivity::class.java)
            // Forward FCM notification extras so getInitialMessage() /
            // onMessageOpenedApp receive the tap payload.
            intent.extras?.let { mainIntent.putExtras(it) }
            startActivity(mainIntent)
            overridePendingTransition(0, 0)
            finish()
        }, SPLASH_DELAY_MS)
    }

    companion object {
        private const val SPLASH_DELAY_MS = 1000L
    }
}
