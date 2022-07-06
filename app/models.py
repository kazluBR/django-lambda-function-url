from django.db import models
from django.utils.html import mark_safe

class Category(models.Model):
    name = models.CharField(max_length=255, unique=True)
    description = models.TextField(blank=True)
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)
    image = models.ImageField(upload_to="categories/%Y/%m/%d", blank=True)

    class Meta:
        ordering = ("name",)
        verbose_name_plural = "categories"

    def __str__(self):
        return self.name

    def image_tag(self):
        if self.image:
            return mark_safe('<img src="%s" width="100px" height="100px" />' % (self.image.url))
    image_tag.short_description = "Image"
