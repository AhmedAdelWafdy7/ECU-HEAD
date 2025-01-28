#include "youtubesearch.h"

YoutubeSearch::YoutubeSearch(QObject *parent, const QString &apiKey)
    : QObject(parent), m_apiKey(apiKey)
{
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished, this, &YoutubeSearch::handleNetworkData);
}

void YoutubeSearch::searchVideos(const QString& search_query)
{
    QUrl url("https://www.googleapis.com/youtube/v3/search");
    QUrlQuery queryParams;
    queryParams.addQueryItem("part", "snippet");
    queryParams.addQueryItem("q", QUrl::toPercentEncoding(search_query));
    queryParams.addQueryItem("maxResults", "5");
    queryParams.addQueryItem("key", "AIzaSyBUbRpC3g43ea6DH7Yp1ngQcyOYGH5UNRY");
    url.setQuery(queryParams);
    
    QNetworkRequest request(url);

    QSslConfiguration config = request.sslConfiguration();
    config.setPeerVerifyMode(QSslSocket::VerifyNone);
    QFile certFile("/etc/ssl/certs/youtube.pem");

    if(certFile.open(QIODevice::ReadOnly))
    {
        QSslCertificate cert(&certFile, QSsl::Pem);
        config.setCaCertificates(QList<QSslCertificate>() << cert);
    }

    request.setSslConfiguration(config);    
    manager->get(request);
}

void YoutubeSearch::handleNetworkData(QNetworkReply* network_reply)
{
    if(network_reply->error() == QNetworkReply::NoError)
    {
        QByteArray response = network_reply->readAll();
        QJsonDocument json_doc = QJsonDocument::fromJson(response);
        QJsonObject json_obj = json_doc.object();
        QJsonArray items = json_obj["items"].toArray();
        
        emit searchResultsReady(items);
    }
    else
    {
        qDebug() << "Error: " << network_reply->errorString();
    }

    network_reply->deleteLater();
}