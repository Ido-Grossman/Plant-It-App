from rest_framework import status
from rest_framework.test import APIClient
from django.test import TestCase
from django.contrib.auth import get_user_model
from rest_framework.authtoken.models import Token

from ....models import Plant, Post, Reply


class TestPosts(TestCase):
    def setUp(self):
        self.user = get_user_model().objects.create_user(
            email='testuser@example.com',
            password='testpass',
            username='testuser'
        )
        self.plant = Plant.objects.create(
            latin='testplant',
            family='testfamily',
            category='testcategory',
            origin='testorigin',
            climate='testclimate',
            toleratedlight='testtoleratedlight',
            idealight='testidealight',
            watering='testwatering',
            water_duration=7,
            mincelsius=10,
            maxcelsius=30,
            minfahrenheit=50,
            maxfahrenheit=86,
            plant_photo='plant_photos/test.jpg',
        )
        self.posts = [
            Post.objects.create(plant=self.plant, title=f'testtitle{i}', content=f'testcontent{i}', user=self.user) for i in range(10)
        ]
        self.token, _ = Token.objects.get_or_create(user=self.user)
        self.client = APIClient()
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)

    def test_get_posts(self):
        url = f'/api/posts/{self.plant.id}/'
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_post_post(self):
        self.client.login(username='testuser', password='testpass')
        response = self.client.post(f'/api/posts/{self.plant.id}/', {'title': 'newtitle', 'content': 'newcontent'})
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Post.objects.count(), 11)
        new_post = Post.objects.latest('date_posted')
        self.assertEqual(new_post.title, 'newtitle')
        self.assertEqual(new_post.content, 'newcontent')


class TestPostReplies(TestCase):
    def setUp(self):
        self.user = get_user_model().objects.create_user(
            email='testuser@example.com',
            password='testpass',
            username='testuser'
        )
        self.plant = Plant.objects.create(
            latin='testplant',
            family='testfamily',
            category='testcategory',
            origin='testorigin',
            climate='testclimate',
            toleratedlight='testtoleratedlight',
            idealight='testidealight',
            watering='testwatering',
            water_duration=7,
            mincelsius=10,
            maxcelsius=30,
            minfahrenheit=50,
            maxfahrenheit=86,
            plant_photo='plant_photos/test.jpg',
        )

        self.post = Post.objects.create(plant=self.plant, title='testpost', content='testcontent', user=self.user)
        self.replies = [
            Reply.objects.create(post=self.post, content=f'testcontent{i}', user=self.user) for i in range(10)
        ]
        self.token, _ = Token.objects.get_or_create(user=self.user)
        self.client = APIClient()
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)

    def test_get_replies(self):
        url = f'/api/posts/{self.plant.id}/{self.post.id}/'
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_post_reply(self):
        url = f'/api/posts/{self.plant.id}/{self.post.id}/'
        response = self.client.post(url, {'content': 'newcontent'})
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Reply.objects.count(), 11)
        new_reply = Reply.objects.latest('date_posted')
        self.assertEqual(new_reply.content, 'newcontent')

    def test_update_post(self):
        url = f'/api/posts/{self.plant.id}/{self.post.id}/'
        response = self.client.put(url, {'title': 'newtitle', 'content': 'newcontent'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.post.refresh_from_db()
        self.assertEqual(self.post.title, 'newtitle')
        self.assertEqual(self.post.content, 'newcontent')

    def test_delete_post(self):
        url = f'/api/posts/{self.plant.id}/{self.post.id}/'
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        with self.assertRaises(Post.DoesNotExist):
            Post.objects.get(pk=self.post.id)