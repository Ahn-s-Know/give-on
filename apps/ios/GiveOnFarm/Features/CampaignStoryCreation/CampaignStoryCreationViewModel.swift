import SwiftUI
import AVFoundation

@MainActor
final class CampaignStoryCreationViewModel: NSObject, ObservableObject {
    @Published var storyText = ""
    @Published var selectedPhotos: [UIImage] = []
    @Published var isRecording = false
    @Published var errorMessage: String?

    private var speechRecognizer: SpeechRecognizer?

    override init() {
        super.init()
    }

    func selectPhoto() {
        // Photo picker implementation
        // This would integrate with PHPickerViewController
    }

    func startVoiceInput() {
        if isRecording {
            stopVoiceInput()
        } else {
            isRecording = true
            speechRecognizer = SpeechRecognizer { [weak self] result in
                switch result {
                case .success(let text):
                    self?.storyText.append(text)
                    self?.isRecording = false
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isRecording = false
                }
            }
            speechRecognizer?.startRecording()
        }
    }

    func stopVoiceInput() {
        isRecording = false
        speechRecognizer?.stopRecording()
    }

    func submitStory() {
        guard !storyText.isEmpty else {
            errorMessage = "이야기를 입력해주세요."
            return
        }

        guard storyText.count <= 500 else {
            errorMessage = "500자 이내로 입력해주세요."
            return
        }

        // Submit to backend
        Task {
            do {
                // API call would go here
                // let response = try await API.submitCampaignStory(
                //     text: storyText,
                //     photos: selectedPhotos
                // )
                print("Story submitted: \(storyText)")
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func removePhoto(at index: Int) {
        guard index < selectedPhotos.count else { return }
        selectedPhotos.remove(at: index)
    }
}

class SpeechRecognizer: NSObject, AVAudioRecorderDelegate {
    typealias CompletionHandler = (Result<String, Error>) -> Void

    private let completionHandler: CompletionHandler
    private var audioRecorder: AVAudioRecorder?

    init(completionHandler: @escaping CompletionHandler) {
        self.completionHandler = completionHandler
    }

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default, options: [])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            let documentsPath = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first!
            let audioFilePath = documentsPath.appendingPathComponent("recording.m4a")

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFilePath, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            completionHandler(.failure(error))
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        completionHandler(.success("음성 입력이 완료되었습니다."))
    }

    func audioRecorderDidFinishRecording(
        _ recorder: AVAudioRecorder,
        successfully flag: Bool
    ) {
        if flag {
            completionHandler(.success("음성 입력이 저장되었습니다."))
        } else {
            let error = NSError(
                domain: "SpeechRecognizer",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "녹음 실패"]
            )
            completionHandler(.failure(error))
        }
    }
}
