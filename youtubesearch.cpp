#include "youtubesearch.h"
#include <cstdlib> 

YouTubeSearch::YouTubeSearch() {
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished, this, &YouTubeSearch::handleNetworkData);
}

void YouTubeSearch::searchVideos(const QString& query) {
    emit searchStarted();
    
    // Retrieve the API key from the environment variable
    const char* apiKey = std::getenv("YOUTUBE_API_KEY");
    if (!apiKey) {
        qDebug() << "Error: YOUTUBE_API_KEY environment variable not set!";
        emit searchError("API key not set");
        return;
    }


    QNetworkRequest request(QUrl("https://www.googleapis.com/youtube/v3/search?part=snippet&q=" + query + 
                                 "&maxResults=5&key=" + QString(apiKey)));

    QSslConfiguration conf = request.sslConfiguration();
    conf.setPeerVerifyMode(QSslSocket::VerifyNone);
    QFile certFile("/etc/ssl/certs/youtube.pem");
    
    if (certFile.open(QIODevice::ReadOnly)) {
        QSslCertificate cert(&certFile, QSsl::Pem);
        conf.setCaCertificates(QList<QSslCertificate>() << cert);
    }
    
    request.setSslConfiguration(conf);

    manager->get(request);
}

void YouTubeSearch::handleNetworkData(QNetworkReply *reply) {
    auto deferSearchFinished = qScopeGuard([this](){ emit searchFinished(); });
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray responseData = reply->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
        QJsonObject jsonObj = jsonDoc.object();
        QJsonArray jsonArray = jsonObj["items"].toArray();

        // Send data to QML
        emit searchResultsReady(jsonArray);
    } else {
        qDebug() << "Error:" << reply->errorString();
        emit searchError(reply->errorString());
    }
    reply->deleteLater();
}
