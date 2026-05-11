import SwiftUI
import PhotosUI

struct MediaItem: Identifiable {
    let id = UUID()
    let name: String
    let sizeInMB: Double
    let thumbnail: UIImage?
}

struct UploadingMediaItem: Identifiable {
    let id = UUID()
    let name: String
    var progress: Double = 0.0
}

@MainActor
final class MediaRegistrationViewModel: NSObject, ObservableObject {
    @Published var uploadedMedia: [MediaItem] = []
    @Published var uploadingMedia: [UploadingMediaItem] = []
    @Published var errorMessage: String?

    private let maxFileCount = 5
    private let maxFileSizeInMB = 100.0

    func selectMedia() {
        // Photo picker implementation
        // This would integrate with PHPickerViewController

        // Simulation for preview
        #if DEBUG
        let mockMedia = MediaItem(
            name: "damage_photo_01.jpg",
            sizeInMB: 3.2,
            thumbnail: UIImage(systemName: "photo.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        )
        uploadedMedia.append(mockMedia)

        let mockUploading = UploadingMediaItem(name: "damage_video_01.mp4")
        uploadingMedia.append(mockUploading)

        // Simulate upload progress
        simulateUploadProgress(for: 0)
        #endif
    }

    func removeMedia(at index: Int) {
        guard index < uploadedMedia.count else { return }
        uploadedMedia.remove(at: index)
    }

    func cancelUpload(at index: Int) {
        guard index < uploadingMedia.count else { return }
        uploadingMedia.remove(at: index)
    }

    private func simulateUploadProgress(for index: Int) {
        Task {
            for progress in stride(from: 0.0, through: 1.0, by: 0.1) {
                try? await Task.sleep(nanoseconds: 500_000_000)
                if index < uploadingMedia.count {
                    uploadingMedia[index].progress = progress
                }
            }

            if index < uploadingMedia.count {
                let uploadingItem = uploadingMedia.remove(at: index)
                let mediaItem = MediaItem(
                    name: uploadingItem.name,
                    sizeInMB: 45.5,
                    thumbnail: UIImage(systemName: "video.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                )
                uploadedMedia.append(mediaItem)
            }
        }
    }

    func validateMediaCount() -> Bool {
        uploadedMedia.count >= 1
    }
}
