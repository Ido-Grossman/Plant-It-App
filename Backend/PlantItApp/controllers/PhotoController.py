import base64
import os
from PIL import Image

from django.core.files.base import ContentFile
from rest_framework.views import APIView
from rest_framework.response import Response
from torchvision.datasets import ImageFolder  # for working with classes and images
import torchvision.transforms as transforms  # for transforming images into tensors
from django.conf import settings
import torch

from ..serializers import *


def save_base64_as_image(data, filename):
    format, imgstr = data.split(';base64,')
    ext = format.split('/')[-1]
    data = ContentFile(base64.b64decode(imgstr), name=filename + '.' + ext)
    return data


class PhotoUploadView(APIView):
    def post(self, request):
        if request.method == 'POST':
            image_file = request.FILES.get('file')
            if image_file:
                # Assuming you want to save the image in a 'media' folder
                img = Image.open(image_file)
                img = img.resize((256, 256))
                img = img.convert('RGB')
                save_path = os.path.join('media\\media', image_file.name)
                img.save(save_path)
        test_pic = 'C:\\Users\\idodd\\PycharmProjects\\Plant-It-App\\Backend\\media'
        test = ImageFolder(test_pic, transform=transforms.ToTensor())
        img, label = test[0]
        yb = settings.MODEL(img.unsqueeze(0))
        _, preds = torch.max(yb, dim=1)
        return Response(int(preds))
