<?php
namespace App\Http\Controllers\Api\V1;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\V1\Auth\LoginRequest;
use App\Http\Requests\Api\V1\Auth\RegisterRequest as RegReq; 
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
class AuthController extends Controller
{
    public function register(RegReq $req) {
        $user = User::create([
            'name'     => $req->name,
            'email'    => $req->email,
            'password' => Hash::make($req->password),
        ]);
        $token = $user->createToken($req->input('device_name','mobile'))->plainTextToken;
        return response()->json([
            'status' => true,
            'message' => 'Registered successfully',
            'data' => [
                'token' => $token,
                'user'  => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'wallet' => $user->wallet,
                ],
            ],
        ], 201);
    }
    public function login(LoginRequest $req) {
        $user = User::where('email', $req->email)->first();
        if (! $user || ! Hash::check($req->password, $user->password)) {
            return response()->json([
                'status' => false,
                'message' => 'Invalid credentials',
            ], 422);
        }
        $token = $user->createToken($req->input('device_name','mobile'))->plainTextToken;
        return response()->json([
            'status' => true,
            'message' => 'Logged in',
            'data' => [
                'token' => $token,
                'user'  => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'wallet' => $user->wallet,
                ],
            ],
        ]);
    }
    public function me(Request $req) {
        return response()->json([
            'status' => true,
            'data' => $req->user(),
        ]);
    }
    public function logout(Request $req) {
        $req->user()?->currentAccessToken()?->delete();
        return response()->json(['status'=>true,'message'=>'Logged out']);
    }
    public function logoutAll(Request $req) {
        $req->user()?->tokens()?->delete();
        return response()->json(['status'=>true,'message'=>'Logged out from all devices']);
    }
    
}
