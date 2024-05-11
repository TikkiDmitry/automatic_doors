from django.urls import path
from .views import AccessToRoomsListCreate, AccessToRoomsUpdate

urlpatterns = [
    path('access/', AccessToRoomsListCreate.as_view(), name='access-list-create'),
    path('access/<int:pk>/', AccessToRoomsUpdate.as_view(), name='access-update'),
]