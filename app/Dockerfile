# 1. Folosim o imagine oficială de Python, varianta "slim" pentru a ocupa puțin spațiu
FROM python:3.9-slim

# 2. Ne creăm un folder de lucru în interiorul containerului
WORKDIR /usr/src/app

# 3. Copiem doar lista de cerințe mai întâi (ajută la Docker Cache pentru viteză)
COPY requirements.txt ./

# 4. Instalăm librăriile (Flask)
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiem restul codului nostru (app.py) în container
COPY . .

# 6. Informăm sistemul că ascultăm pe portul 5000
EXPOSE 5000

# 7. Comanda care ține aplicația aprinsă
CMD ["python", "app.py"]