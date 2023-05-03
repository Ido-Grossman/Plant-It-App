from django.contrib.auth import get_user_model
from rest_framework import serializers
from .models import Plant, UserPlants, Disease, Post, Reply


class PhotoSerializer(serializers.Serializer):
    image = serializers.CharField()


# a serializer for the plant.
class PlantSerializer(serializers.ModelSerializer):
    common = serializers.StringRelatedField(many=True, read_only=True)
    use = serializers.StringRelatedField(many=True, read_only=True)

    class Meta:
        model = Plant
        fields = '__all__'


# a serializer for the plant search results.
class PlantSearchSerializer(serializers.ModelSerializer):
    common = serializers.StringRelatedField(many=True, read_only=True)
    use = serializers.StringRelatedField(many=True, read_only=True)

    class Meta:
        model = Plant
        fields = ['id', 'latin', 'common', 'plant_photo', 'common', 'category', 'use', 'mincelsius', 'maxcelsius', 'climate']


# a serializer for the plant diseases.
class DiseaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Disease
        fields = '__all__'


# a serializer for the user's plants.
class UserPlantsSerializer(serializers.ModelSerializer):
    plant = PlantSerializer()
    disease = DiseaseSerializer()

    class Meta:
        model = UserPlants
        fields = '__all__'


class PostSerializer(serializers.ModelSerializer):
    # Get the username of user_id
    user = serializers.SerializerMethodField('get_username_from_user_id')

    class Meta:
        model = Post
        fields = '__all__'

    def get_username_from_user_id(self, post):
        username = post.user.username
        return username


# a serializer for replies.
class ReplySerializer(serializers.ModelSerializer):
    # Get the username of user_id
    user = serializers.SerializerMethodField('get_username_from_user_id')

    class Meta:
        model = Reply
        fields = '__all__'

    def get_username_from_user_id(self, reply):
        username = reply.user.username
        return username


class UserRegistrationSerializer(serializers.Serializer):
    email = serializers.EmailField()
    username = serializers.CharField(max_length=100, required=False)
    uid = serializers.CharField(max_length=100, required=False)
    password = serializers.CharField(max_length=100, required=False)

    def __init__(self, *args, **kwargs):
        # If the user is registering with email, username, and password, then all fields are required.
        super().__init__(*args, **kwargs)
        if self.context.get('require_username', False):
            self.fields['username'].required = True
        if self.context.get('require_uid', False):
            self.fields['uid'].required = True
        if self.context.get('require_password', False):
            self.fields['password'].required = True

    def validate_username(self, value):
        # If the user is registering with email, username, and password, then the username must be unique.
        User = get_user_model()
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("User already exists.")
        return value

    def validate_email(self, value):
        # If the user is registering with email, username, and password, then the email must be unique.
        User = get_user_model()
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already exists.")
        return value


class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ['username', 'profile_picture']
