#ifndef YOUTUBESEARCH_H
#define YOUTUBESEARCH_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QSslConfiguration>

class YoutubeSearch : public QObject
{
    Q_OBJECT
public:
    explicit YoutubeSearch(QObject *parent = nullptr, const QString &apiKey = QString());

    Q_INVOKABLE void searchVideos(const QString& search_query);

signals:
    void searchResultsReady(const QJsonArray& search_results);

private slots:
    void handleNetworkData(QNetworkReply* network_reply);

private:
    QString m_apiKey;
    QNetworkAccessManager *manager;
};

#endif // YOUTUBESEARCH_H
