//
//  GPT.swift
//  Linguo
//
//  Created by Steve Alex on 31/08/2024.
//

import Foundation
import SwiftUI

func translateText(text: String, language: String) async -> String {
    let prompt = """
        Translate the following text into \(language)
        \(text)
        Only return the translated text, make the translation as accurate and comprehensive as possible
    """
    let response = try await fetchOpenAIMessageResponse(prompt: prompt)
    return response ?? "Unable to retrieve translation"
}

func classifyAndTranslateImage(image: UIImage, language: String) async -> String {
    let prompt = """
        Can you label this image as accurately and succintly as possible?
        Translate your label into \(language)
    
        Return in the following format:
        "This is where the translated text in \(language) goes"
    
        "This is where the labelled text goes"
    """
    let base64ImageUrl = getBase64ImageUrl(image: image)
    let response = try await fetchOpenAIImageClassificationResponse(image: base64ImageUrl, prompt: prompt)
    print("response => \(response)")
    return response ?? ""
}

func getBase64ImageUrl(image: UIImage) -> String {
    let jpegData = image.jpegData(compressionQuality: 0.1)
    let base64Image = jpegData?.base64EncodedString()
    return "data:image/jpeg;base64,\(base64Image ?? "")"
}


func fetchOpenAIImageClassificationResponse(image: String?, prompt: String) async -> String {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    let imageClassificationRequestBody = serialissedImageClassificationRequestBody(image: image, prompt: prompt)

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer", forHTTPHeaderField: "Authorization")
    request.httpBody = imageClassificationRequestBody

    do {
        let (data, _) = try await URLSession.shared.data(for: request)

        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonDict = jsonObject as? [String: Any],
              let choices = jsonDict["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String

        else {
            return "Unable to label content"
        }

        return content

    } catch {
        return "Unable to label content"
    }
}

func serialissedImageClassificationRequestBody(image: String?, prompt: String) -> Data? {
    let requestBody = [
        "model": "gpt-4o-mini",
        "messages": [
            [
                "role": "user",
                "content": [
                    [
                        "type": "text",
                        "text": prompt
                    ],
                    [
                        "type": "image_url",
                        "image_url": [
                            "url": image
                        ]
                    ]
                ]
            ]
        ]
    ] as [String : Any]

    guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
        return nil
    }
    
    return httpBody
}


func fetchOpenAIMessageResponse(prompt: String) async -> String? {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    let messageRequestBody = serialissedMessageRequestBody(prompt: prompt)
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer", forHTTPHeaderField: "Authorization")
    request.httpBody = messageRequestBody

    do {
        let (data, _) = try await URLSession.shared.data(for: request)

        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let jsonDict = jsonObject as? [String: Any],
              let choices = jsonDict["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String

        else {
            return ""
        }

        return content

    } catch {
        return "Unable to fetch content"
    }
}


func serialissedMessageRequestBody(prompt: String) -> Data? {
    let requestBody = [
        "model": "gpt-4",
        "messages": [
            [
                "role": "user",
                "content": prompt
            ]
        ]
    ] as [String : Any]

    guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
        return nil
    }

    return httpBody
}
