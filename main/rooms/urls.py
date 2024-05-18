from django.urls import path
from .views import AccessToRoomsCreate, AccessToRoomsUpdate, RoomsList

urlpatterns = [
    path('access/', AccessToRoomsCreate.as_view(), name='access-create'),
    path('access/<int:pk>/', AccessToRoomsUpdate.as_view(), name='access-update'),
    path('list/', RoomsList.as_view(), name='rooms-list'),
]