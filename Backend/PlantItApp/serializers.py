from django.contrib.auth import get_user_model
from rest_framework import serializers


class PhotoSerializer(serializers.Serializer):
    image = serializers.CharField()


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
