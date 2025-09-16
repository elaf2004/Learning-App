<?php
// database/migrations/2025_01_01_000000_create_teachers_table.php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('teachers', function (Blueprint $t) {
            $t->id();
            $t->string('name');
            $t->string('email')->unique()->nullable(); // اختياري
            $t->string('avatar')->nullable();          // صورة المدرّس (path)
            $t->text('bio')->nullable();
            $t->timestamps();
        });
    }
    public function down(): void { Schema::dropIfExists('teachers'); }
};
