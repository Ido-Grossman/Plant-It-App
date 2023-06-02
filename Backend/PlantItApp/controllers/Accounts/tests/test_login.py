from django.contrib.sessions.middleware import SessionMiddleware
from django.test import TestCase, RequestFactory
from django.urls import reverse
from rest_framework.test import APITestCase, APIClient
from rest_framework.authtoken.models import Token

from ....backends import CustomUser
from ..LoginController import log_user_in, login


def add_session_to_request(request):
    middleware = SessionMiddleware(lambda req: None)
    middleware.process_request(request)
    request.session.save()


class LoginUnitTest(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.user = CustomUser.objects.create_user(email='test@example.com', password='password123')

    def test_log_user_in(self):
        request = self.factory.post('/login/', {'email': 'test@example.com', 'password': 'password123'})
        request.user = self.user
        add_session_to_request(request)

        response = log_user_in(self.user, request)

        self.assertEqual(response.status_code, 200)
        self.assertTrue('token' in response.data)


class LoginIntegrationTest(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.user = CustomUser.objects.create_user(email='test1@example.com', password='password123')

    def test_login(self):
        request = self.factory.post('/login/', {'email': 'test1@example.com', 'password': 'password123'})
        request.user = self.user

        response = login(request)

        self.assertEqual(response.status_code, 200)
        self.assertTrue('token' in response.data)


class LoginAPITest(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = CustomUser.objects.create_user(email='test@example.com', password='password123')

    def test_login_api(self):
        data = {'email': 'test@example.com', 'password': 'password123'}
        response = self.client.post(reverse('login'), data)

        self.assertEqual(response.status_code, 200)
        self.assertTrue('token' in response.data)
