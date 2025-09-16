<?php
namespace App\Http\Requests\Api\V1\Auth;

use Illuminate\Foundation\Http\FormRequest;

class RegisterRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array {
        return [
            'name'         => ['required','string','max:100'],
            'email'        => ['required','email','max:255','unique:users,email'],
            'password'     => ['required','string','min:8','confirmed'], // يستخدم password_confirmation
            'device_name'  => ['nullable','string','max:100'],
        ];
    }
}
