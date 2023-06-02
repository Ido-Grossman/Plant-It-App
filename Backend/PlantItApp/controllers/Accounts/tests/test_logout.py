from django.test import TestCase, RequestFactory
from django.urls import reverse
from rest_framework.test import APITestCase, APIClient
from rest_framework.authtoken.models import Token

from .test_login import add_session_to_request
from ....backends import CustomUser
from ..LogoutController import logout


class LogoutUnitTest(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.user = CustomUser.objects.create_user(email='test1@example.com', password='password123')
        self.token = Token.objects.create(user=self.user)

    def test_logout(self):
        request = self.factory.post('/logout/')
        request.user = self.user
        add_session_to_request(request)
        request.META['HTTP_AUTHORIZATION'] = 'Token ' + self.token.key

        response = logout(request)

        self.assertEqual(response.status_code, 200)


class LogoutAPITest(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = CustomUser.objects.create_user(email='test1@example.com', password='password123')
        self.token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)

    def test_logout_api(self):
        response = self.client.post(reverse('logout'))

        self.assertEqual(response.status_code, 200)