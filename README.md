# MFM Desktop Assistant

The MFM (Multi-Functional Module) is a desktop assistant that integrates AI-powered programming queries and process monitoring capabilities. It consists of a Dockerized Python Flask API backend and an Electron-based transparent floating interface.

## Host Requirements

- **Operating System:** Linux (required for host /proc access)
- **Docker:** Installed and running
- **Node.js and npm:** For running the Electron interface
- **Rclone:** Mentioned for future persistence features (not implemented in current MFM)

## Obtaining Gemini API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Create a new API key
4. Copy the API key for use in the environment variable

## Running the Docker Container

### Build the Image
```bash
docker build -t mfm-api .
```

### Run the Container
Execute the container with the required volume mount for host /proc access and set the Gemini API key:
```bash
docker run -p 5000:5000 -v /proc:/host/proc:ro -e GEMINI_API_KEY=AIzaSyC1mvlI2BITv4FRJ7IzSD9GATYdUQWIsG8 mfm-api
```

**Important:** The `-v /proc:/host/proc:ro` mapping is critical for the process monitoring functionality.

## Running the Electron Interface

### Prerequisites
- Docker container running (as above)
- Node.js and npm installed

### Installation
Navigate to the electron-interface directory and install dependencies:
```bash
cd electron-interface
npm install
```

### Launch the Application
Start the Electron app:
```bash
npm start
```

### Usage
- Press `Ctrl+Shift+G` (or `Cmd+Shift+G` on Mac) to show/hide the dialog popup
- The dialog appears in the bottom-right corner with a semi-transparent background
- The dialog contains:
  - A QR code assistant with visual state feedback (border color changes)
  - A history area displaying the last 5 chat interactions
  - An input field for IA/Chat queries
  - An input field for Process Monitoring

## Testing the Main Functionalities

### AI Query Functionality
1. Show the dialog with `Ctrl+Shift+G`
2. In the "Ask IA..." input field, enter a programming query (e.g., "How to implement a binary search in Python?")
3. Click "Send" or press Enter
4. Observe the QR code border turn blue during processing
5. View the interaction added to the history area (last 5 interactions)
6. The QR code border will turn green on success or red on error

### Process Monitoring Functionality
1. In the "Process name..." input field, enter a process name (e.g., "bash" or "systemd")
2. Click "Check" or press Enter
3. Observe the QR code border turn blue during checking
4. View the status message in the temporary notification bubble over the history
5. The QR code border will turn green if the process is running, red if not

## API Endpoints

- `POST /api/query_gemini` - Send programming queries to Gemini AI
  - Body: `{"query": "your question"}`
  - Response: `{"response": "AI answer"}`
- `GET /api/check_process?process_name=name` - Check if a process is running
  - Response: `{"is_running": true/false, "message": "status description"}`
- `GET /api/check_host_access` - Test host /proc access (debugging)

## Troubleshooting

- Ensure the Docker container is running and accessible on port 5000
- Verify the GEMINI_API_KEY environment variable is set correctly
- Check that /proc is properly mounted in the container
- Confirm Node.js and npm are installed for the Electron interface