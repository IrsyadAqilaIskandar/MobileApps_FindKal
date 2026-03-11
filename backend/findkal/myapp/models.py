from django.db import models

# Create your models here.
class User(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=100)
    nomortelepon = models.CharField(max_length=20)
    negara = models.CharField(max_length=50)
    provinsi = models.CharField(max_length=50)
    kota = models.CharField(max_length=50)
    kecamatan = models.CharField(max_length=50)
    kelurahan = models.CharField(max_length=50)
    

    def __str__(self):
        return self.name
    
