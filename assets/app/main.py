from io import StringIO, BytesIO
import base64
import re
from PIL import Image
import pytesseract
from flask import Flask, request

port = 55001
app = Flask(__name__)


@app.route("/")
def hello_world():
    return 'OCR SERVER ONLINE'


@app.route('/ocr/cu', methods=['POST'])
def ocr():
    regex = r"\b([a-zA-Z]+'?[a-zA-Z]+)\b"
    # Get image as BASE64
    requestJson = request.get_json(silent=True)
    image = Image.open(BytesIO(base64.b64decode(requestJson["img"])))
    image = image.crop((1348,1078,3152,1146)) # Rect generated from https://www.maschek.hu/imagemap/

    # Extract text and split to line
    extractedText = pytesseract.image_to_string(image)
    #lines = extractedText.splitlines()

    # Find the name
    #indices = [i for i, s in enumerate(lines) if 'AL DIPENDENTE 1 2 3' in s]
    #nameFound = lines[indices[0] + 1].replace("PENSIONATO O ", "").replace("PENSIONATO ", "")

    # Remove unused charaters
    #matches = re.finditer(regex, nameFound)
    #name = ""
    #for matchNum, match in enumerate(matches, start=1):
    #    name = name + match.group() + " "

    return extractedText



app.run(port=port)
