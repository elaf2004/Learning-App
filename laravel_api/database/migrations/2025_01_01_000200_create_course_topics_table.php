<?php
// database/migrations/2025_01_01_000200_create_course_topics_table.php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('course_topics', function (Blueprint $t) {
            $t->id();
            $t->foreignId('course_id')->constrained('courses')->cascadeOnDelete();
            $t->string('title');
            $t->text('content')->nullable();           // وصف/نص الدرس
            $t->unsignedSmallInteger('order')->default(1);
            $t->unsignedInteger('duration_minutes')->nullable();
            $t->timestamps();

            $t->unique(['course_id','order']);        // ترتيب فريد داخل الكورس
        });
    }
    public function down(): void { Schema::dropIfExists('course_topics'); }
};
