from rest_framework.decorators import api_view, authentication_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework import status
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile


@api_view(['PUT'])
@authentication_classes([TokenAuthentication])
def upload_profile_picture(request):
    user = request.user
    if not user.is_authenticated:
        return Response({'error': 'Unauthorized access'}, status=status.HTTP_401_UNAUTHORIZED)
    image = request.FILES.get('file', None)
    if not image:
        return Response({'error': 'Please provide an image'}, status=status.HTTP_400_BAD_REQUEST)
    file_name = f"{user.id}-profile-picture.jpg"
    file_path = f"profile_pictures/{file_name}"
    file = ContentFile(image.read())
    file_size = default_storage.save(file_path, file)
    if file_size:
        user.profile_picture = file_path
        user.save()
        image_url = default_storage.url(file_path)
        print(image_url)
        return Response({'success': 'Profile picture uploaded successfully', 'image_url': image_url})
    else:
        return Response({'error': 'Profile picture upload failed'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
