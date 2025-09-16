<?php
// app/Http/Requests/Api/V1/Auth/LoginRequest.php
namespace App\Http\Requests\Api\V1\Auth;

use Illuminate\Foundation\Http\FormRequest;

class LoginRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array {
        return [
            'email'       => ['required','email'],
            'password'    => ['required','string'],
            'device_name' => ['nullable','string','max:100'],
        ];
    }
}
