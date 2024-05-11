from django.contrib import admin
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from .views import CustomUserDetail, ScheduleDetail, EntryExitListCreate

# На счет входа/выхода подумать, нужно ли по id получать проходы или достаточно общего списка
urlpatterns = [
    path('users/<int:pk>/', CustomUserDetail.as_view(), name='customuser-detail'),
    path('schedule/<int:pk>/', ScheduleDetail.as_view(), name='schedule-detail'),
    path('entryexit/', EntryExitListCreate.as_view(), name='entryexit-list-create'),
]
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)