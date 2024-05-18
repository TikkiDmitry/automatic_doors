from django.contrib import admin
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from .views import CustomUserDetail, ScheduleDetail, EntryExitListCreate, CurrentUserView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

# На счет входа/выхода подумать, нужно ли по id получать проходы или достаточно общего списка
urlpatterns = [
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('accounts/<int:pk>/', CustomUserDetail.as_view(), name='customuser-detail'),
    path('schedule/<int:pk>/', ScheduleDetail.as_view(), name='schedule-detail'),
    path('entryexit/', EntryExitListCreate.as_view(), name='entryexit-list-create'),
    path('current/', CurrentUserView.as_view(), name='current-user'),
]
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)