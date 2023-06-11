from rest_framework.decorators import api_view, authentication_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework import status
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile


@api_view(['PUT'])
@authentication_classes([TokenAuthentication])
def upload_profile_picture(request):
    # Get the user
    user = request.user
    # Check if the user is authenticated
    if not user.is_authenticated:
        return Response({'error': 'Unauthorized access'}, status=status.HTTP_401_UNAUTHORIZED)
    # Check if the request contains an image
    image = request.FILES.get('file', None)
    if not image:
        return Response({'error': 'Please provide an image'}, status=status.HTTP_400_BAD_REQUEST)
    # Save the image
    file_name = f"{user.id}-profile-picture.jpg"
    file_path = f"profile_pictures/{file_name}"
    file = ContentFile(image.read())
    file_size = default_storage.save(file_path, file)
    # Check if the image was saved
    if file_size:
        # Update the user profile picture
        user.profile_picture = file_path
        user.save()
        image_url = default_storage.url(file_path)
        return Response(image_url, status=status.HTTP_200_OK)
    else:
        # Return an error if the image wasn't saved
        return Response({'error': 'Profile picture upload failed'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
