import pdfplumber

with pdfplumber.open('木及附件.pdf') as pdf:
    full_text = ''
    for i, page in enumerate(pdf.pages):
        text = page.extract_text()
        if text:
            full_text += f'=== PAGE {i+1} ===\n'
            full_text += text + '\n\n'

    # Output all text
    print(full_text)
