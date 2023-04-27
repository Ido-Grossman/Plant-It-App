from django.contrib.auth import get_user_model
from rest_framework import serializers
from .models import Plant, UserPlants


class PhotoSerializer(serializers.Serializer):
    image = serializers.CharField()


# a serializer for the plant with its common names and uses
class PlantSerializer(serializers.ModelSerializer):
    common = serializers.StringRelatedField(many=True, read_only=True)
    use = serializers.StringRelatedField(many=True, read_only=True)

    class Meta:
        model = Plant
        fields = '__all__'


class PlantSearchSerializer(serializers.ModelSerializer):
    common = serializers.StringRelatedField(many=True, read_only=True)

    class Meta:
        model = Plant
        fields = ['id', 'latin', 'common', 'plant_photo', 'common', 'category']


# a serializer for the user's plants.
class UserPlantsSerializer(serializers.ModelSerializer):
    plant = PlantSerializer()

    class Meta:
        model = UserPlants
        fields = '__all__'


class UserRegistrationSerializer(serializers.Serializer):
    email = serializers.EmailField()
    username = serializers.CharField(max_length=100, required=False)
    uid = serializers.CharField(max_length=100, required=False)
    password = serializers.CharField(max_length=100, required=False)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.context.get('require_username', False):
            self.fields['username'].required = True
        if self.context.get('require_uid', False):
            self.fields['uid'].required = True
        if self.context.get('require_password', False):
            self.fields['password'].required = True

    def validate_username(self, value):
        User = get_user_model()
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("User already exists.")
        return value

    def validate_email(self, value):
        User = get_user_model()
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already exists.")
        return value


class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ['username', 'profile_picture']
