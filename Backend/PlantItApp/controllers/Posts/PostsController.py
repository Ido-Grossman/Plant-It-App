from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.views import APIView

from PlantItApp.models import Post
from PlantItApp.serializers import PostSerializer


class Posts(APIView):
    authentication_classes = [TokenAuthentication]

    def get(self, request, plant_id):
        # give me the 10 most recent posts of this plant
        posts = Post.objects.filter(plant_id=plant_id).order_by('-date_posted')[:10]
        # change the user_id to the username
        serializer = PostSerializer(posts, many=True)
        return Response(data=serializer.data, status=status.HTTP_200_OK)

    def post(self, request, plant_id):
        # create a new post for this plant
        content = request.data.get('content')
        title = request.data.get('title')
        if not content or not title:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        post = Post.objects.create(plant_id=plant_id, content=content, title=title, user=request.user)
        serializer = PostSerializer(post)
        return Response(data=serializer.data, status=status.HTTP_201_CREATED)
