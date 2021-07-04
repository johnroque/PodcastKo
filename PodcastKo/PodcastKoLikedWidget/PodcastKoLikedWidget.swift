//
//  PodcastKoLikedWidget.swift
//  PodcastKoLikedWidget
//
//  Created by John Roque Jorillo on 7/4/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import WidgetKit
import SwiftUI

struct LikedPodcastsEntry: TimelineEntry {
    let date = Date()
    let likedPodcasts: [Podcast]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> LikedPodcastsEntry {
        LikedPodcastsEntry(likedPodcasts: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LikedPodcastsEntry) -> Void) {
        let entry = LikedPodcastsEntry(likedPodcasts: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LikedPodcastsEntry>) -> Void) {
        let favPodcasts = AppUserDefaults.shared.getObjectWithKey(.favoritedPodcastKey, type: [Podcast].self)
        let entry = LikedPodcastsEntry(likedPodcasts: favPodcasts ?? [])
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct FavoriteListView: View {
    var favoritePodcast: [Podcast]
    
    var body: some View {
        ZStack {
            Color.init(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            if let podcast = favoritePodcast.last {
                VStack(alignment: .center, spacing: 8) {
                    Text(podcast.trackName ?? "")
                        .font(.system(size: 10, weight: .bold, design: .default))
                        .foregroundColor(Color.init(UIColor.label))
                        .lineLimit(3)
                        .minimumScaleFactor(8/10)
                        .truncationMode(.middle)

                    Text(podcast.artistName ?? "")
                        .font(.system(size: 8, weight: .regular, design: .default))
                        .foregroundColor(Color.init(UIColor.secondaryLabel))
                        .truncationMode(.middle)
                        .lineLimit(2)
                    
                    Text("Your favorite podcast")
                        .font(.system(size: 8, weight: .bold, design: .default))
                        .foregroundColor(Color.init(UIColor.label))
                        .lineLimit(2)
                        .minimumScaleFactor(8/10)
                        .truncationMode(.middle)
                }
                .padding(.all, 8)
            } else {
                Text("Theres no favorite podcast yet.")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(Color.init(UIColor.label))
                    .padding(.all, 8)
            }
        }
    }
}

struct PodcastKoLikedEntryView: View {
    let entry: Provider.Entry
    
    var body: some View {
        FavoriteListView(favoritePodcast: entry.likedPodcasts)
    }
}

@main
struct PodcastKoLikedWidget: Widget {
    private let kind = "PodcastKoLikedWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()) { entry in
            PodcastKoLikedEntryView(entry: entry)
        }
    }
}
