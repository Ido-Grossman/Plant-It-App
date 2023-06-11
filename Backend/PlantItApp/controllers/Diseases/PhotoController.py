from PIL import Image
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, authentication_classes
from rest_framework.response import Response
import torchvision.transforms as transforms  # for transforming images into tensors
from django.conf import settings
from PlantItApp.models import Disease
from PlantItApp.serializers import DiseaseSerializer

import torch


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
def photo_upload(request):
    if not request.user.is_authenticated:
        return Response('User not authenticated', status=status.HTTP_401_UNAUTHORIZED)
    image_file = request.FILES.get('file')
    if not image_file:
        return Response('No image file uploaded', status=status.HTTP_400_BAD_REQUEST)
    # Load the image and resize it to 256x256 pixels.
    img = Image.open(image_file)
    img = img.resize((256, 256))
    # Transform the image into a tensor.
    transform = transforms.ToTensor()
    img = transform(img)
    # Get the prediction from the model.
    yb = settings.MODEL(torch.unsqueeze(img, 0))
    _, preds = torch.max(yb, dim=1)
    # Get the disease name from the settings file.
    disease_name = settings.DISEASES[preds[0].item()]
    disease = Disease.objects.get(disease=disease_name)
    # Return the disease data.
    serializer = DiseaseSerializer(disease)
    return Response(data=serializer.data, status=status.HTTP_200_OK)
