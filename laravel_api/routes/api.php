<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\TeacherController;
use App\Http\Controllers\Api\V1\CourseController;
use App\Http\Controllers\Api\V1\CourseTopicController;
use App\Http\Controllers\Api\V1\ProgressController;

Route::prefix('v1')->group(function () {
    // Auth (public)
    Route::post('auth/register', [AuthController::class, 'register']);
    Route::post('auth/login',    [AuthController::class, 'login']);

    // Public read-only
    Route::get('teachers',                 [TeacherController::class, 'index']);
    Route::get('teachers/{teacher}',       [TeacherController::class, 'show']);
    Route::get('courses',                  [CourseController::class, 'index']);
    Route::get('courses/{course}',         [CourseController::class, 'show']);
    Route::get('courses/{course}/topics',  [CourseTopicController::class, 'index']);

    // Protected
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('auth/me',        [AuthController::class, 'me']);
        Route::post('auth/logout',   [AuthController::class, 'logout']);
        Route::post('auth/logout-all', [AuthController::class, 'logoutAll']);

        // قائمة كورسات المستخدم بصيغة موحّدة متوافقة مع Flutter MyCoursesModel
        Route::get('my-courses', [ProgressController::class, 'index']);

        // إدارة المحتوى
        Route::post('courses',                        [CourseController::class, 'store']);
        Route::match(['put','patch'], 'courses/{course}', [CourseController::class, 'update']);
        Route::delete('courses/{course}',             [CourseController::class, 'destroy']);

        Route::post('courses/{course}/topics',        [CourseTopicController::class, 'store']);
        Route::match(['put','patch'], 'topics/{topic}',   [CourseTopicController::class, 'update']);
        Route::delete('topics/{topic}',               [CourseTopicController::class, 'destroy']);
    });
});
