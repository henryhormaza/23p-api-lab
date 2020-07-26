from P23_API_LAB import app

if __name__ == "__main__":
    from waitress import serve
    serve(app, host="0.0.0.0", port=8000, channel_timeout=1200)