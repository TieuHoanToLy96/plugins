import { Modal, Card, Table, Button, Input, Avatar } from "antd"
import { EditOutlined, DeleteOutlined } from '@ant-design/icons' 
import { useEffect, useState } from "react"
import getConfig from "next/config"

import Pagination from "/cus-components/Pagination"
import { sendGet, sendPost } from "/utils/request"
import produce from "immer";

const publicRuntimeConfig = getConfig().publicRuntimeConfig

const ModalEditSite = props => {
  const { closeModal, goToPage } = props
  const [data, setData] = useState(props ?.data || {})

  const handleChangeFieldData = (key, value) => {
    setData(produce(data, draft => {
      draft[key] = value
    }))
  }

  const onClickOk = () => {
    if (data ?.id) {
      updateSite()
    } else {
      createSite()
    }
  }

  const updateSite = () => {
    let url = `${publicRuntimeConfig.API_URL}/sites/update`
    sendPost(url, null, data)
      .then(res => {
        if (res.status == 200) {
          goToPage()
          closeModal()
        }
      })
  }

  const createSite = () => {
    let url = `${publicRuntimeConfig.API_URL}/sites/create`
    sendPost(url, null, data)
      .then(res => {
        if (res.status == 200) {
          goToPage()
          closeModal()
        }
      })
  }

  useEffect(() => {
    setData(props?.data)
  }, [props?.data])

  return (
    <Modal centered title={data ?.id ? `Edit site ${data.name}` : "Create site"} className="cus-modal" visible={true} onOk={onClickOk} onCancel={closeModal}>
      <div className="form-section mb-16">
        <div className="label">Name</div>
        <Input value={data ?.name} onChange={e => handleChangeFieldData("name", e.target.value)} />
      </div>

      <div className="form-section">
        <div className="label">Url</div>
        <Input value={data ?.url} onChange={e => handleChangeFieldData("url", e.target.value)} />
      </div>
    </Modal>
  )
}

const SiteList = props => {
  const [visibleModal, setVisibleModal] = useState(false)
  const [sites, setSites] = useState({})
  const [selectedSite, setSelectedSite] = useState({})

  const onClickEdit = record => e => {
    e.stopPropagation()
    setSelectedSite(record)
    setVisibleModal(true)
  }

  const onClickCreate = () => {
    setVisibleModal(true)
  }

  const onClickRow = record => e => {
    window.open(`${window.location.origin}/sites/${record.id}/dashboard`)
  }

  const goToPage = (page, limit, term) => {
    let url = `${publicRuntimeConfig.API_URL}/sites/all?page=${page}&limit=${limit}&term=${term}`
    sendGet(url).then(res => {
      if (res.status == 200) {
        setSites(res.data.sites)
      }
    })
  }

  useEffect(() => {
    goToPage(1, 15)
  }, [])

  return (
    <div className="site-list bg-red-800">
      <div className="site-list--header">
        <div className="site-list--header__logo">
          <img src="https://statics.pancake.vn/web-media/30/32/72/c5/64b0c023de47bc9c971f7d20217369e2dc8ba3b164325e2e1f328f81.png" />
          <div>Plugs</div>
        </div>
      </div>

      <div className="site-list--content mt-24">
        <Card className="cus-card">
          <div className="is-flex is-flex--space-between mb-16">
            <div><Input className="cus-input" /></div>
            <Button style={{width: 100}} onClick={onClickCreate} type="primary" className="cus-button">Create site</Button>
          </div>
          <Table
            bordered
            pagination={false}
            className="cus-table site-table"
            dataSource={sites ?.data || []}
            onRow={(record, rowIndex) => {
              return {
                onClick: onClickRow(record)
              };
            }} >
            <Table.Column title="Site name" render={(value, record) => (
              <div>
                <div>{record.name}</div>
                <div style={{ color: "var(--color-text-light)" }}>{record.url}</div>
              </div>
            )} />
            <Table.Column width={200} title="Creator" render={(value, record) => (
              <div className="is-flex">
                <Avatar size="small" src={record?.creator?.avatar} />
                <div className="ml-8">{(record?.creator?.first_name || record?.creator?.last_name) ? (record?.creator?.first_name + record?.creator?.last_name) : record?.creator?.email}</div>
              </div>
            )}/>
            <Table.Column width={100} title={<div className="is-flex is-flex--vcenter is-flex--hcenter">Action</div>}
              render={(value, record) => (
                <div className="is-flex is-flex--vcenter is-flex--hcenter">
                  <EditOutlined onClick={onClickEdit(record)} className="is-cursor" />
                  <DeleteOutlined className="is-cursor ml-16" style={{color: "var(--danger)"}} />
                </div>
              )}/>
          </Table>
          <div className="mt-16"><Pagination page={sites?.page} limit={sites?.limit} totalEntries={sites?.total_entries}/></div>
        </Card>
      </div>

      {
        visibleModal &&
        <ModalEditSite data={selectedSite} closeModal={() => setVisibleModal(false)} goToPage={goToPage}/>
      }
    </div>
  )
}

export default SiteList