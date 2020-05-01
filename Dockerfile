# FROM nvcr.io/nvidia/pytorch:19.12-py3
FROM pytorch/pytorch:0.4.1-cuda9-cudnn7-runtime

RUN apt-get update && apt-get install -y \
	python3-pip software-properties-common wget && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy BASNet.
COPY BASNet ./BASNet

# Copy Resnet.
COPY resnet34-333f7ec4.pth /root/.torch/models/resnet34-333f7ec4.pth

# Install production dependencies.
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy local code to the container image.
COPY *.py ./

# Set default port.
ENV PORT 80

# Run the web service using gunicorn.
CMD exec gunicorn --bind :$PORT --workers 1 main:app