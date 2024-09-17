FROM python

WORKDIR /app

COPY requirements.txt requirement.txt
RUN pip install -r requirement.txt 

COPY app.py app.py

CMD ["python", "-m", "app"]