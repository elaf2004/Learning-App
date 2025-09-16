<?php
// app/Models/UserCourseProgress.php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class UserCourseProgress extends Model {
    use HasFactory;
    protected $table = 'user_course_progress';
    protected $fillable = ['user_id','course_id','progress','last_topic_id'];
    public function user()   { return $this->belongsTo(User::class); }
    public function course() { return $this->belongsTo(Course::class); }
    public function lastTopic() { return $this->belongsTo(CourseTopic::class, 'last_topic_id'); }
}
