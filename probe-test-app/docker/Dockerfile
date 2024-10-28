FROM python:3.12.7-bookworm

RUN useradd --user-group --system --no-log-init --create-home python
USER python
WORKDIR /home/python

COPY --chown=python:python requirements.txt requirements.txt
RUN pip install --user -r requirements.txt

ENV PATH="/home/python/.local/bin:${PATH}"

COPY --chown=python:python . .

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "probetest:app"]