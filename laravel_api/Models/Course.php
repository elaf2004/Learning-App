<?php
// app/Models/Course.php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Course extends Model {
    use HasFactory;
    protected $fillable = ['title','price','image','category','teacher_id','description'];
    public function teacher() { return $this->belongsTo(Teacher::class); }
    public function topics()  { return $this->hasMany(CourseTopic::class)->orderBy('order'); }
    public function progress() { return $this->hasMany(UserCourseProgress::class); }
}
