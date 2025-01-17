# trunk-ignore-all(black)
from flask import Flask, render_template_string, request

app = Flask(__name__)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Image Proxy</title>
</head>
<body>
  <img src="{{ image_url }}" alt="Proxied Image">
</body>
</html>
"""


@app.route("/image")
def proxy_image():
    image_url = request.args.get("url")
    if not image_url:
        return "No image URL provided", 400

    html_content = render_template_string(HTML_TEMPLATE, image_url=image_url)
    return html_content

@app.route("/health")
def health():
    return "OK"

if __name__ == "__main__":
    # trunk-ignore(bandit/B104)
    app.run(host="0.0.0.0", port=8000)
