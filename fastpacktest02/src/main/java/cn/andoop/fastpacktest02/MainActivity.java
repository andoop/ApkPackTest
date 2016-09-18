package cn.andoop.fastpacktest02;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void getChannel(View view){
        Toast.makeText(MainActivity.this,MCPTool.getChannelId(this,"12345678",""), Toast.LENGTH_SHORT).show();
    }
}
