const express = require('express');
const { exec } = require('child_process');

const app = express();
const port = process.env.PORT || 3000;

// ดึงสตรีมจาก URL และแปลงเป็น HLS
app.get('/stream', (req, res) => {
    const inputUrl = 'https://iptv2.wirdy.workers.dev/02_PremierHD1_720p/chunklist.m3u8'; // เปลี่ยนเป็น URL จริง
    const output = 'output.m3u8';

    const ffmpegCmd = `ffmpeg -i ${inputUrl} -c:v copy -c:a copy -hls_time 5 -hls_list_size 10 -hls_flags delete_segments ${output}`;
    
    exec(ffmpegCmd, (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            return res.status(500).send('FFmpeg error');
        }
        res.sendFile(__dirname + '/' + output);
    });
});

app.listen(port, () => console.log(`Server running on port ${port}`));
