<?php
// database/migrations/2025_01_01_000100_create_courses_table.php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('courses', function (Blueprint $t) {
            $t->id();
            $t->string('title');
            $t->decimal('price', 10, 2)->default(0);
            $t->string('image')->nullable(); // path داخل storage/public
            $t->enum('category', ['UI/UX','Animation','Design','Flutter','Python']);
            $t->foreignId('teacher_id')->constrained('teachers')->cascadeOnDelete();
            $t->text('description')->nullable();
            $t->timestamps();
        });
    }
    public function down(): void { Schema::dropIfExists('courses'); }
};
