from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, authentication_classes
from rest_framework.response import Response
from django.shortcuts import get_object_or_404

from PlantItApp.models import Post, Reply
from PlantItApp.serializers import ReplySerializer, PostSerializer


@api_view(['GET', 'POST', 'DELETE', 'PUT'])
@authentication_classes([TokenAuthentication])
def post_replies(request, plant_id, post_id):
    if not request.user.is_authenticated:
        return Response(status=status.HTTP_401_UNAUTHORIZED)
    post = get_object_or_404(Post, pk=post_id)
    if request.method == 'GET':
        # give me the 10 most recent replies of this post
        replies = Reply.objects.filter(post_id=post_id).order_by('-date_posted')[:10]
        # change the user_id to the username
        serializer = ReplySerializer(replies, many=True)
        return Response(data=serializer.data, status=status.HTTP_200_OK)
    elif request.method == 'POST':
        # create a new reply for this post
        content = request.data.get('content')
        if not content:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        reply = Reply.objects.create(post_id=post_id, content=content, user=request.user)
        serializer = ReplySerializer(reply)
        return Response(data=serializer.data, status=status.HTTP_201_CREATED)
    elif request.method == 'PUT':
        # update this post
        if post.user != request.user:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        content = request.data.get('content')
        title = request.data.get('title')
        if not content or not title:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        post.content = content
        post.title = title
        post.save()
        serializer = PostSerializer(post)
        return Response(data=serializer.data, status=status.HTTP_200_OK)
    else:
        # delete this post
        if post.user != request.user:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        post.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
