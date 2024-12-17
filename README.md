# **OpenAI Swift SDK**

![ENV Screenshot](/usage_preview.png)

## **Overview**

The **OpenAI Swift SDK** is a fully-featured Swift package designed to integrate OpenAI's Assistants API into third party Swift applications. This project demonstrates advanced API interactions, streaming responses, image uploads, file handling, and message threading using modern SwiftUI, Swift Concurrency (async/await), and dependency injection patterns.

This README covers:

1. **Features**
2. **Installation & Setup**
3. **Project Environment Configuration**
4. **API Usage**
5. **Example Workflows**
6. **Troubleshooting & Best Practices**

---

## **1. Features**

- **Thread Management**
    - Create new threads dynamically.
    - Load cached threads.
    - Delete threads with confirmation dialogs.

- **Message Management**
    - Send messages with text content or attached images.
    - Stream responses in real-time from OpenAI APIs.
    - Display messages in a chat-like UI.

- **Image & File Handling**
    - Upload image files to OpenAI.
    - Retrieve and display image content using `NSImage`.
    - Preview attached images before sending.

- **Real-Time Streaming**
    - Efficiently fetch and display streamed text responses as they are received.
    - Scroll to the bottom automatically when new messages are added.

- **Modular Design**
    - Decoupled `NetworkService` for clean API interactions.
    - Extendable `ViewModel` for state management.

---

## **2. Installation & Setup**

### **Prerequisites**

1. **Xcode 15 or later**  
   Ensure you have Xcode installed with Swift 5.9+ support.

2. **Dependencies**
    - macOS 13.0+
    - Swift Concurrency enabled.

### **Cloning the Repository**

```bash
git clone https://github.com/paolodellaquila/OpenAI-Swift.git
```

---

## **3. Project Environment Configuration**

To compile and execute correctly, the following **environment keys** are required. Add these keys to your Xcode project's environment or use a `.env` file.

| Key                     | Description                     | Example Value                  |
|-------------------------|---------------------------------|--------------------------------|
| `OPENAI_API_KEY`        | Your OpenAI API Key             | `sk-XXXXXXXXXXXXXXXXXX`        |
| `OPENAI_ORGANIZATION_ID`| Your OpenAI Organization ID     | `org-XXXXXXXXXXXX`             |
| `OPENAI_ASSISTANT_ID`   | The Assistant ID to use         | `asst-XXXXXXXXXXXXXXXXXX`      |

---

### **Adding Environment Variables**

#### **Method 1: Xcode Scheme Configuration**
1. Open Xcode and go to your **Project Scheme**:
    - `Product > Scheme > Edit Scheme...`
2. Under the **Run** section:
    - Add the keys in the **Environment Variables** tab.

| Variable               | Value                          |
|------------------------|--------------------------------|
| `OPENAI_API_KEY`       | Your actual API key            |
| `OPENAI_ORGANIZATION_ID` | Your organization ID           |
| `OPENAI_ASSISTANT_ID`  | Assistant ID from OpenAI       |

![ENV Screenshot](/env_example.jpg)


#### **Method 2: Environment File (.env)**
- Use tools like [DotEnv](https://github.com/SwiftDotEnv) to load `.env` files dynamically.

Example `.env` file:

```env
OPENAI_API_KEY=sk-XXXXXXXXXXXXXXXXXX
OPENAI_ORGANIZATION_ID=org-XXXXXXXXXXXX
OPENAI_ASSISTANT_ID=asst-XXXXXXXXXXXXXXXXXX
```

---

## **4. API Usage**
The project uses `NetworkService` and `ContentViewModel` to handle OpenAI APIs.

![ENV Screenshot](./demo_preview.png)

### **Endpoints and Usage**

1. **Thread Management**

- **Create a Thread**
   ```swift
   viewModel.openThread()
   ```

- **Delete a Thread**
   ```swift
   viewModel.deleteThread(thread)
   ```

2. **Message Handling**

- **Create a Message**
   ```swift
   viewModel.createMessage()
   ```

- **Streamed Response**  
  Real-time response streaming with scrolling:

   ```swift
   viewModel.run(threadId)
   ```

3. **Image Uploads**

- Upload and preview images:
   ```swift
   viewModel.attachImage()
   ```

- Display fetched images dynamically using `NSImage`.

---

## **5. Example Workflows**

### **A. Sending Text Messages**

1. Enter a prompt in the input field.
2. Click "Send" to trigger the API call.
3. View the streaming response in the center UI.

### **B. Attaching and Sending Images**

1. Click the **paperclip icon** to attach an image.
2. Preview the image in the attached image bar.
3. Send the image with a text message using "Send".

### **C. Managing Threads**

1. Open new threads with "Add New Thread".
2. Select threads from the sidebar.
3. Delete threads with the trash icon.

---

## **6. Troubleshooting & Best Practices**

### **Common Issues**

1. **Environment Keys Not Set**
    - Ensure all required keys are set in your environment.
    - Verify the keys in Xcode's Scheme Configuration.

2. **Stream Freezes**
    - Check API response for errors and debug logs.
    - Verify the connection is stable.

3. **Decoding Errors**
    - Ensure your model structures match the OpenAI API schema.

### **Logging**

Enable debug logging by setting `debugEnabled = true` in network calls to print JSON responses.

---

## **7. Contribution**

Contributions are welcome! 🚀🚀
1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/my-feature
   ```
3. Submit a pull request.

---

## **8. License**

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## **9. Support**

For any questions or issues, open an issue in this repository, or reach out to [OpenAI Support](https://platform.openai.com/docs/support). 


