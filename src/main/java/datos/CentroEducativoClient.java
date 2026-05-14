package datos;
import okhttp3.*;
import com.google.gson.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CentroEducativoClient {
    private static final String BASE_URL = "http://localhost:9090/CentroEducativo";
    private static final MediaType JSON   = MediaType.get("application/json");

    // ── CookieJar en memoria para mantener la JSESSIONID ──────────────
    private final Map<String, List<Cookie>> cookieStore = new HashMap<>();

    private final OkHttpClient http = new OkHttpClient.Builder()
            .cookieJar(new CookieJar() {
                @Override
                public void saveFromResponse(HttpUrl url, List<Cookie> cookies) {
                    cookieStore.put(url.host(), cookies);
                }
                @Override
                public List<Cookie> loadForRequest(HttpUrl url) {
                    List<Cookie> cookies = cookieStore.get(url.host());
                    return cookies != null ? cookies : new ArrayList<>();
                }
            })
            .build();

    // ── El resto de métodos igual que antes ───────────────────────────
    public String login(String dni, String password) throws IOException {
        JsonObject body = new JsonObject();
        body.addProperty("dni", dni);
        body.addProperty("password", password);

        Request req = new Request.Builder()
                .url(BASE_URL + "/login")
                .post(RequestBody.create(body.toString(), JSON))
                .build();

        try (Response res = http.newCall(req).execute()) {
            if (res.isSuccessful() && res.body() != null) {
                return res.body().string().trim().replace("\"", "");
            }
            return null;
        }
    }

    public String get(String endpoint, String key) throws IOException {
        HttpUrl url = HttpUrl.parse(BASE_URL + endpoint)
                .newBuilder()
                .addQueryParameter("key", key)
                .build();

        Request req = new Request.Builder()
                .url(url)
                .addHeader("Accept", "application/json")
                .get()
                .build();

        try (Response res = http.newCall(req).execute()) {
            if (res.isSuccessful() && res.body() != null) {
                return res.body().string();
            }
            System.out.println("Fallo GET " + endpoint + ": " + res.code());
            return null;
        }
    }

    public boolean put(String endpoint, String key, String jsonBody) throws IOException {
        HttpUrl url = HttpUrl.parse(BASE_URL + endpoint)
                .newBuilder()
                .addQueryParameter("key", key)
                .build();

        Request req = new Request.Builder()
                .url(url)
                .put(RequestBody.create(jsonBody, JSON))
                .build();

        try (Response res = http.newCall(req).execute()) {
            return res.isSuccessful();
        }
    }
    
    public String loginYGet(String endpoint, String dni, String password) throws IOException {
        String key = this.login(dni, password);
        if (key == null) return null;
        return this.get(endpoint, key);
    }
    

    public static void main(String[] args) {
        CentroEducativoClient cliente = new CentroEducativoClient();
        try {
            System.out.println("Intentando conectar con CentroEducativo...");
            String key = cliente.login("111111111", "654321");

            if (key != null) {
                System.out.println("Login EXITOSO, KEY: " + key);
                String asignaturas = cliente.get("/asignaturas", key);
                System.out.println("Asignaturas: " + asignaturas);
            } else {
                System.out.println("Login fallido");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}