from PIL import Image
from rest_framework.views import APIView
from rest_framework.response import Response
import torchvision.transforms as transforms  # for transforming images into tensors
from django.conf import settings
import torch
import os


class PhotoUploadView(APIView):
    def post(self, request):
        if request.method == 'POST':
            image_file = request.FILES.get('file')
            if image_file:
                # Assuming you want to save the image in a 'media' folder
                img = Image.open(image_file)
                img = img.resize((256, 256))
                transform = transforms.ToTensor()
                img = transform(img)
                yb = settings.MODEL(torch.unsqueeze(img, 0))
                _, preds = torch.max(yb, dim=1)
                return Response(settings.DISEASES[preds[0].item()])
