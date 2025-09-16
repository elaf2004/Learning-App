<?php
// database/migrations/2025_01_01_000300_create_user_course_progress_table.php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('user_course_progress', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->foreignId('course_id')->constrained('courses')->cascadeOnDelete();
            $t->unsignedTinyInteger('progress')->default(0); // 0..100 %
            $t->foreignId('last_topic_id')->nullable()->constrained('course_topics')->nullOnDelete();
            $t->timestamps();

            $t->unique(['user_id','course_id']);
        });
    }
    public function down(): void { Schema::dropIfExists('user_course_progress'); }
};
