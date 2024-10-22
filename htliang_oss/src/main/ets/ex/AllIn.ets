import axios, {
  AxiosError,
  AxiosHeaders,
  AxiosProgressEvent,
  AxiosResponse,
  InternalAxiosRequestConfig,
  Method,
  RawAxiosRequestHeaders,
} from '@ohos/axios'
const instance = axios.create({
  baseURL: "https://oss-cn-guangzhou.aliyuncs.com",
  timeout: 30000,
})

instance.interceptors.request.use(
  async (config: InternalAxiosRequestConfig) => {



    // 对请求数据做点什么
    // Log.info(`1-请求配置${config.method!}-${config.url}：${JSON.stringify(config.params || config.data)}`)
    // 1. 统一添加 token

    // console.log('config.url ===>' + config.url)
    // console.log('config.data ===>' + JSON.stringify(config.data))
    // 加密
    console.log("xxxxjson" + config)
    // config.data =
    //   `uzCODXyUP5utp1DtLr5VMx6qbXiApwiksHWEl3Ny6fvIwkrH3UCqrysrA2QM wuWRp/Y6jS/u+EfRDn5xE2eZ2Ee4QvafZpoegpB5iewJr1PG/CBFFiimcgYB 6lDTTeArwhF9hmFq+tOVR8P7kdDDvMxRCCrVXKKOfi67Mim3qVjtw2r19P9q yqsO3LmEZFsDis0zZnI488m1la1fxxBDXw==`

    // Log.info(JSON.stringify(config.data))
    // console.log('Log--  ==>' + JSON.stringify(config.data))

    return config
  })

instance.interceptors.response.use((response: AxiosResponse) => {
  console.log("xxxre:+"+response.data)



  return response.data

},
  (error: ESObject) => {
    console.log('Log--- error==>' + JSON.stringify(error))

    // 对响应错误做点什么
    return Promise.reject(error)
  })


// 请求参数
interface RequestParams<T> {
  url: string
  method?: Method
  params?: T
  data?: T
  headers?: RawAxiosRequestHeaders | AxiosHeaders
  context?: Context
  onUploadProgress?: (progressEvent: AxiosProgressEvent) => void
}

export function Request<DataModel = null, DataParams = null>(requestParams: RequestParams<DataParams>): Promise<DataModel> {
  return instance<string, DataModel>(requestParams)
}


export { instance }