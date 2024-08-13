package com.example.mycampuscampus; // Update with your package name

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;
import com.example.mycampus.R;


public class MyWidgetProvider extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            // Intent to handle button click
            Intent intent = new Intent(context, MyWidgetProvider.class);
            intent.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds);

            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

            // Update the widget view
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_layout);

            // Set up the button click event
            views.setOnClickPendingIntent(R.id.widget_button, pendingIntent);

            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);

        if (Intent.ACTION_TIME_CHANGED.equals(intent.getAction())) {
            // Handle time change
        } else if (AppWidgetManager.ACTION_APPWIDGET_UPDATE.equals(intent.getAction())) {
            // Handle button click or widget update
            // Update widget content here
        }
    }
}
