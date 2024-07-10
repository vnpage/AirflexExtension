import MobileCoreServices

@objcMembers
public class AirflexExtension {
    public class func didReceiveNotificationExtensionRequest (_ request: UNNotificationRequest, with attemptContent: UNMutableNotificationContent, withContentHandler contentHandler: ((UNNotificationContent) -> Void)?) {
        if let contentHandler = contentHandler {
            if let attachmentURLString = attemptContent.userInfo["image"] as? String, let attachmentURL = URL(string: attachmentURLString) {
                let session = URLSession(configuration: .default)
                let task = session.downloadTask(with: attachmentURL) { (tempURL, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        contentHandler(attemptContent)
                        return
                    }
                    guard let tempURL = tempURL else {
                        contentHandler(attemptContent)
                        return
                    }
                    
                    let identifier = ProcessInfo.processInfo.globallyUniqueString
                    let options = [UNNotificationAttachmentOptionsTypeHintKey: kUTTypeJPEG]
                    
                    do {
                        let attachment = try UNNotificationAttachment(identifier: identifier, url: tempURL, options: options)
                        attemptContent.attachments = [attachment]
                        contentHandler(attemptContent)
                    } catch {
                        print("Error creating attachment: \(error)")
                        contentHandler(attemptContent)
                    }
                }
                task.resume()
            } else {
                contentHandler(attemptContent)
            }
        }
    }
    
    public class func serviceExtensionTimeWillExpireRequest(_ request: UNNotificationRequest, with attemptContent: UNMutableNotificationContent?) {
        
    }
}
